package com.example.primerparcialmovil.adaptadores;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import com.example.primerparcialmovil.DTO.Producto;
import com.example.primerparcialmovil.R;
import com.example.primerparcialmovil.tempActivity;
import com.squareup.picasso.Picasso;

import org.jetbrains.annotations.NotNull;


public class ProductoAdapter extends ListAdapter<Producto, ProductoAdapter.ProductoViewHolder> {


    public ProductoAdapter(@NonNull @NotNull DiffUtil.ItemCallback<Producto> diffCallback) {
        super(diffCallback);
    }

    @NonNull
    @NotNull
    @Override
    public ProductoViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        return ProductoViewHolder.create(parent);
    }
    public static class Userdiff extends DiffUtil.ItemCallback<Producto> {

        @Override
        public boolean areItemsTheSame(@NonNull Producto oldItem, @NonNull Producto newItem) {
            return oldItem == newItem;
        }

        @Override
        public boolean areContentsTheSame(@NonNull Producto oldItem, @NonNull Producto newItem) {
            return oldItem.getId() == newItem.getId();
        }
    }


    @Override
    public void onBindViewHolder(@NonNull @NotNull ProductoViewHolder holder, int position) {
        Producto prodcut = getItem(position);

        //holder.name.setText(prodcut.titulo);
        holder.titulo.setText(prodcut.getTitulo());
        holder.desc.setText(prodcut.getDescripcion());
        Picasso.get().load(prodcut.getLogo()).into(holder.img);

        holder.botoncito.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Context context = view.getContext();
                Intent intent = new Intent(context, tempActivity.class);
                intent.putExtra("dato_key",  prodcut.getId());
                context.startActivity(intent);
            }
        });

    }



    public static class ProductoViewHolder extends RecyclerView.ViewHolder {

        TextView titulo;
        TextView desc;

        ImageView img;

        Button botoncito;

        private LinearLayout parentLayout;
        private Context context;
        public ProductoViewHolder(@NonNull @NotNull View itemView) {
            super(itemView);

            titulo = itemView.findViewById(R.id.titles);
            desc = itemView.findViewById(R.id.desc);
            img = itemView.findViewById(R.id.imgg);
            botoncito = itemView.findViewById(R.id.botoncito);

            parentLayout = itemView.findViewById(R.id.linear_layout); // R.id.parent_layout es el ID del LinearLayout en item_info_recycle.xml
            context = itemView.getContext();

//            parentLayout.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    int position = getAdapterPosition();
//                    User user = getItem(position);
//                    Intent intent = new Intent(context, InfoRecycle.class);
//                    intent.putExtra("dato_key", String.valueOf(user.getId()));
//                    context.startActivity(intent);
//                }
//            });

        }
        public static ProductoViewHolder create(ViewGroup parent) {
            View view = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.item_object, parent, false);
            return new ProductoViewHolder(view);
        }
    }

}
