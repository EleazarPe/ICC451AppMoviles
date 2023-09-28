package com.example.httpretrofit;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.httpretrofit.DTO.UserSingle;
import com.example.httpretrofit.api.APIClient;
import com.example.httpretrofit.api.APIInterface;
import com.squareup.picasso.Picasso;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class InfoRecycle extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_info_recycle);
        //Toast.makeText(this, getIntent().getStringExtra("dato_key"), Toast.LENGTH_SHORT).show();
        APIInterface api = APIClient.getClient().create(APIInterface.class);
        api.find(Integer.parseInt(getIntent().getStringExtra("dato_key"))).enqueue(new Callback<UserSingle>() {
            @Override
            public void onResponse(Call<UserSingle> call, Response<UserSingle> response) {
                //--->
                TextView t1 = findViewById(R.id.nombre);
                TextView t2 = findViewById(R.id.correo);
                ImageView i1 = findViewById(R.id.foto);
                t1.setText(response.body().data.getFirstName()+" "+response.body().data.getLastName());
                t2.setText(response.body().data.getEmail().toString());
                Picasso.get().load(response.body().data.getAvatar()).into(i1);
            }

            @Override
            public void onFailure(Call<UserSingle> call, Throwable t) {
                Toast.makeText(getApplicationContext(), "No se pudo cargar", Toast.LENGTH_SHORT).show();
                call.cancel();
            }
        });

    }
}