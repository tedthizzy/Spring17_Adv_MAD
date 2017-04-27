package com.example.aileen.recipes;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

public class RecipeMainActivity extends AppCompatActivity {

    // Firebase database instance
    FirebaseDatabase database = FirebaseDatabase.getInstance();
    //Firebase database reference
    DatabaseReference ref = database.getReference();

    //array list of recipes
    List recipes = new ArrayList<>();
    //array adapter
    ArrayAdapter<RecipeItem> listAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_recipe_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
//                        .setAction("Action", null).show();

                final Dialog dialog = new Dialog(RecipeMainActivity.this);
                dialog.setContentView(R.layout.dialog);
                dialog.setTitle("Add Recipe");
                dialog.setCancelable(true);
                final EditText nameEditText = (EditText) dialog.findViewById(R.id.editTextName);
                final EditText urlEditText = (EditText) dialog.findViewById(R.id.editTextURL);
                Button button = (Button) dialog.findViewById(R.id.addButton);
                button.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        String recipeName = nameEditText.getText().toString();
                        String recipeURL = urlEditText.getText().toString();
                        if (recipeName.trim().length() > 0) {
                            //create new recipe item
                            RecipeItem newRecipe = new RecipeItem(recipeName, recipeURL);
                            //add to the array list
                            recipes.add(newRecipe);
                            //refresh the list view
                            listAdapter.notifyDataSetChanged();
                            //add to Firebase
                            ref.child(recipeName).setValue(newRecipe);
                            dialog.dismiss();
                        } else {
                            Context context = getApplicationContext();
                            CharSequence text = getString(R.string.add_recipe_toast);
                            int duration = Toast.LENGTH_SHORT;

                            Toast toast = Toast.makeText(context, text, duration);
                            toast.show();
                        }
                    }
                });
                dialog.show();
            }
        });

        ListView recipeList = (ListView) findViewById(R.id.listView);
        listAdapter = new ArrayAdapter<RecipeItem>(this, android.R.layout.simple_list_item_1, recipes);
        recipeList.setAdapter(listAdapter);

        // Read from the database
        ValueEventListener firebaseListener = new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                // This method is called once with the initial value and again
                // whenever data at this location is updated.

                //empty the arraylist
                recipes.clear();
                for(DataSnapshot snapshot : dataSnapshot.getChildren()){
                    //create new RecipeItem object
                    RecipeItem newRecipe = snapshot.getValue(RecipeItem.class);
                    //add new recipe to our array
                    recipes.add(newRecipe);
                    Log.d("data", "Value is: " + newRecipe.getName() + newRecipe.geturl());
                }
                //update adapter
                listAdapter.notifyDataSetChanged();
            }

            @Override
            public void onCancelled(DatabaseError error) {
                // Failed to read value
                Log.w("oncreate", "Failed to read value.", error.toException());
            }
        };

        //add listener to our database reference
        ref.addValueEventListener(firebaseListener);
        registerForContextMenu(recipeList);

        //create listener
        AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener(){
            public void onItemClick(AdapterView<?> listView, View view, int position, long id){
                //get tapped recipe
                RecipeItem recipeTapped = (RecipeItem) recipes.get(position);
                //get the recipe url
                String recipeURL = recipeTapped.geturl();
                //create new intent
                Intent intent = new Intent(Intent.ACTION_VIEW);
                //add url to intent
                intent.setData(Uri.parse(recipeURL));
                //start intent
                startActivity(intent);
            }
        };
        recipeList.setOnItemClickListener(itemClickListener);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_recipe_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override public void onCreateContextMenu(ContextMenu menu, View view, ContextMenu.ContextMenuInfo menuInfo){
        super.onCreateContextMenu(menu, view, menuInfo);
        //cast ContextMenu.ContextMenuInfo to AdapterView.AdapterContextMenuInfo since we're using an adapter
        AdapterView.AdapterContextMenuInfo adapterContextMenuInfo = (AdapterView.AdapterContextMenuInfo) menuInfo;
        //get recipe name that was pressed
        String recipename = ((TextView) adapterContextMenuInfo.targetView).getText().toString();
        //set the menu title
        menu.setHeaderTitle("Delete " + recipename);
        //add the choices to the menu
        menu.add(1, 1, 1, "Yes");
        menu.add(2, 2, 2, "No");
    }

    @Override public boolean onContextItemSelected(MenuItem item){
        //get the id of the item
        int itemId = item.getItemId();
        if (itemId == 1) { //if yes menu item was pressed
            //get the position of the menu item
            AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) item.getMenuInfo();
            //get recipe name that was pressed
            String recipename = ((TextView) info.targetView).getText().toString();
            //remove the recipe
            recipes.remove(info.position);
            //refresh the list view
            listAdapter.notifyDataSetChanged();
            //delete from Firebase
            ref.child(recipename).removeValue();
        }
        return true;
    }


}
