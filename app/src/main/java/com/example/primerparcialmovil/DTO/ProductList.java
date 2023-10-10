package com.example.primerparcialmovil.DTO;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ProductList implements Serializable {
    @SerializedName("products")
    public List<Producto> product =  new ArrayList<>();

    @SerializedName("total")
    public int total;

    @SerializedName("skip")
    public int skip;
    @SerializedName("limit")
    public int limit;

    public ProductList(List<Producto> product, int total, int skip, int limit) {
        this.product = product;
        this.total = total;
        this.skip = skip;
        this.limit = limit;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getSkip() {
        return skip;
    }

    public void setSkip(int skip) {
        this.skip = skip;
    }

    public int getLimit() {
        return limit;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

    public List<Producto> getProduct() {
        return product;
    }

    public void setProduct(List<Producto> product) {
        this.product = product;
    }
}
