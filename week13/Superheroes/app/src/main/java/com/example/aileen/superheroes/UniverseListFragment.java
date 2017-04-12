package com.example.aileen.superheroes;


import android.os.Bundle;
//import android.support.v4.app.Fragment;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.content.Context;
import android.widget.AdapterView;

/**
 * A simple {@link Fragment} subclass.
 */
public class UniverseListFragment extends Fragment implements AdapterView.OnItemClickListener{

    //create listener
    private UniverseListListener listener;

    public UniverseListFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_universe_list, container, false);
    }

    @Override
    public void onStart(){
        super.onStart();
        View view = getView();
        if (view != null){
            //load data into fragment
            //get the list view
            ListView listUniverse = (ListView) view.findViewById(R.id.listView);
            //define an array adapter
            ArrayAdapter<Hero> listAdapter = new ArrayAdapter<Hero>(getActivity(), android.R.layout.simple_list_item_1, Hero.heroes);
            //set the array adapter on the list view
            listUniverse.setAdapter(listAdapter);

            //attach the listener to the listview
            listUniverse.setOnItemClickListener(this);
        }
    }

    //create interface
    interface UniverseListListener{
        void itemClicked(long id);
    }

    @Override public void onAttach(Context context){
        super.onAttach(context);
        //attaches the context to the listener
        listener = (UniverseListListener) context;
    }

    @Override public void onItemClick(AdapterView<?> parent, View view, int position, long id){
        if (listener != null){
            //tells the listener an item was clicked
            listener.itemClicked(id);
        }
    }

}
