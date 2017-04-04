package com.example.aileen.springnew;

import android.app.Activity;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

public class BulbActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bulb);

        //get bulb data from the intent
        int bulbnum = (Integer)getIntent().getExtras().get("bulbid");
        String type = (String)getIntent().getExtras().get("bulbtype");
        Bulb bulb = Bulb.tulips[bulbnum];

        //populate image
        ImageView bulbImage = (ImageView)findViewById(R.id.bulbImageView);
        bulbImage.setImageResource(bulb.getImageResourceID());

        //populate name
        TextView bulbName = (TextView)findViewById(R.id.bulb_name);
        bulbName.setText(bulb.getName());
    }
}
