package com.example.aileen.springnew;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class BulbCategoryActivity extends ListActivity {
    private String bulbtype;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //create new intent
        Intent i = getIntent();
        bulbtype = i.getStringExtra("bulbtype");

        //get the list view
        ListView listBulbs = getListView();

        //define an array adapter
        ArrayAdapter<Bulb> listAdapter;

        //initialize the array adapter with the right list of bulbs
        switch (bulbtype){
            case "Tulips":
                listAdapter = new ArrayAdapter<Bulb>(this, android.R.layout.simple_list_item_1, Bulb.tulips);
                break;
            default: listAdapter = new ArrayAdapter<Bulb>(this, android.R.layout.simple_list_item_1, Bulb.tulips);
        }

        //set the array adapter on the list view
        listBulbs.setAdapter(listAdapter);
    }

    @Override
    public void onListItemClick(ListView listView, View view, int position, long id){
        Intent intent = new Intent(BulbCategoryActivity.this, BulbActivity.class);
        intent.putExtra("bulbid", (int) id);
        intent.putExtra("bulbtype", bulbtype);
        startActivity(intent);
    }

}
