package com.example.httpretrofit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.example.httpretrofit.DTO.User;
import com.example.httpretrofit.DTO.UserList;
import com.example.httpretrofit.adaptadores.UserAdapter;
import com.example.httpretrofit.api.APIClient;
import com.example.httpretrofit.api.APIInterface;
import com.example.httpretrofit.databinding.ActivityMainBinding;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class MainActivity extends AppCompatActivity {
    private ActivityMainBinding binding;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        RecyclerView recyclerView = binding.recycler;

        int spanCount = 2;

        if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            spanCount = 4;
        }

        recyclerView.setHasFixedSize(true);
        //recyclerView.setLayoutManager(new LinearLayoutManager(getApplicationContext()));
        recyclerView.setLayoutManager(new GridLayoutManager(getApplicationContext(), spanCount));
        APIInterface api = APIClient.getClient().create(APIInterface.class);
        api.findAll().enqueue(new Callback<UserList>() {
            @Override
            public void onResponse(Call<UserList> call, Response<UserList> response) {
                recyclerView.setAdapter(new UserAdapter(response.body().data));
            }

            @Override
            public void onFailure(Call<UserList> call, Throwable t) {
                Toast.makeText(getApplicationContext(), "No se pudo cargar los datos", Toast.LENGTH_SHORT).show();
                call.cancel();
            }
        });

    }
}