package com.example.httpretrofit.api;



import com.example.httpretrofit.DTO.UserList;
import com.example.httpretrofit.DTO.UserSingle;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;

public interface APIInterface {

    @GET("users")
    Call<UserList> findAll();

    @GET("users/{id}")
    Call<UserSingle> find(@Path("id") int id);


}
