package com.example.primerparcialmovil.api;

import com.example.primerparcialmovil.DTO.ProductList;
import com.example.primerparcialmovil.DTO.Producto;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;
import retrofit2.http.Query;

public interface APIInterface {
    @GET("products")
    Call<ProductList> findAll();
    @GET("products/search")
    Call<ProductList> searchProducts(@Query("q") String query);
    @GET("products/{id}")
    Call<Producto> find(@Path("id") int id);
}
