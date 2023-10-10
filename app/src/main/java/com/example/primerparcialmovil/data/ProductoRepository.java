package com.example.primerparcialmovil.data;

import android.app.Application;
import android.util.Log;

import androidx.lifecycle.MutableLiveData;

import com.example.primerparcialmovil.DTO.ProductList;
import com.example.primerparcialmovil.DTO.Producto;
import com.example.primerparcialmovil.api.APIClient;
import com.example.primerparcialmovil.api.APIInterface;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProductoRepository {
    private MutableLiveData<List<Producto>> usersLiveData = new MutableLiveData<>();
    private final APIInterface api;

    ProductoRepository(Application application){
        api = APIClient.getClient().create(APIInterface.class);
        api.findAll().enqueue(new Callback<ProductList>() {
            @Override
            public void onResponse(Call<ProductList> call, Response<ProductList> response) {
                Log.w("onResponse", "OK!");
                usersLiveData.setValue(response.body().product);
            }

            @Override
            public void onFailure(Call<ProductList> call, Throwable t) {
                Log.w("onFailure", t.getMessage());
                call.cancel();
            }
        });
    }


    public MutableLiveData<List<Producto>> getProductsLiveData() {
        return usersLiveData;
    }
}
