package com.example.primerparcialmovil;

import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.res.Configuration;
import android.os.Bundle;
import android.widget.Toast;

import com.example.primerparcialmovil.DTO.ProductList;
import com.example.primerparcialmovil.DTO.Producto;
import com.example.primerparcialmovil.adaptadores.ProductoAdapter;
import com.example.primerparcialmovil.api.APIClient;
import com.example.primerparcialmovil.api.APIInterface;
import com.example.primerparcialmovil.data.ProductoViewModel;
import com.example.primerparcialmovil.databinding.ActivityMainBinding;

import java.util.List;

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

        int spanCount = 1;

        if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            spanCount = 2;
        }

        recyclerView.setHasFixedSize(true);
        //recyclerView.setLayoutManager(new LinearLayoutManager(getApplicationContext()));
        recyclerView.setLayoutManager(new GridLayoutManager(getApplicationContext(), spanCount));
        APIInterface api = APIClient.getClient().create(APIInterface.class);
        ProductoAdapter adapter = new ProductoAdapter(new ProductoAdapter.Userdiff());
        recyclerView.setAdapter(adapter);

        ProductoViewModel userViewModel = new ViewModelProvider(this).get(ProductoViewModel.class);

        userViewModel.getProductsLiveData().observe(this, users -> {
            api.findAll().enqueue(new Callback<ProductList>() {
                @Override
                public void onResponse(Call<ProductList> call, Response<ProductList> response) {
                    //recyclerView.setAdapter(new UserAdapter(response.body().data));
                    adapter.submitList(response.body().product);
                }

                @Override
                public void onFailure(Call<ProductList> call, Throwable t) {
                    Toast.makeText(getApplicationContext(), "No se pudo cargar los datos", Toast.LENGTH_SHORT).show();
                    call.cancel();
                }
            });
        });
        //APII

//        api.findAll().enqueue(new Callback<List<Producto>>() {
//            @Override
//            public void onResponse(Call<List<Producto>> call, Response<List<Producto>> response) {
//                Toast.makeText(getApplicationContext(), "Funciona", Toast.LENGTH_SHORT).show();
//            }
//
//            @Override
//            public void onFailure(Call<List<Producto>> call, Throwable t) {
//                Toast.makeText(getApplicationContext(), "No se pudo cargar los datos", Toast.LENGTH_SHORT).show();
//                call.cancel();
//            }
//        });

//        api.find(3).enqueue(new Callback<Producto>() {
//            @Override
//            public void onResponse(Call<Producto> call, Response<Producto> response) {
//                //recyclerView.setAdapter(new UserAdapter(response.body().data));
//                Toast.makeText(getApplicationContext(), "Funciona", Toast.LENGTH_SHORT).show();
//
//            }
//
//            @Override
//            public void onFailure(Call<Producto> call, Throwable t) {
//                Toast.makeText(getApplicationContext(), "No se pudo cargar los datos", Toast.LENGTH_SHORT).show();
//                call.cancel();
//            }
//        });

//        productoViewModel.getUsersLiveData().observe(this, productos -> {
//            adapter.submitList(productos);
//        });


    }
}