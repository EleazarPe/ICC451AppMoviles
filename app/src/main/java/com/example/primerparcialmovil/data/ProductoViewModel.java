package com.example.primerparcialmovil.data;

import android.app.Application;

import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.MutableLiveData;


import com.example.primerparcialmovil.DTO.Producto;

import java.util.List;

public class ProductoViewModel extends AndroidViewModel {

    private ProductoRepository mRepository;

    private static MutableLiveData<List<Producto>> usersLiveData;

    public ProductoViewModel(Application application) {
        super(application);
        mRepository = new ProductoRepository(application);
        usersLiveData = mRepository.getProductsLiveData();
    }

    public static MutableLiveData<List<Producto>> getProductsLiveData() {
        return usersLiveData;
    }
}