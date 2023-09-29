package com.example.myapplication.adapters;



import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.example.myapplication.R;
import com.example.myapplication.encapsulaciones.Tarea;
import com.example.myapplication.tempActivity;

import org.jetbrains.annotations.NotNull;
import java.util.List;

public class TareaRAdapter extends RecyclerView.Adapter<TareaRAdapter.TareaViewHolder>  {
    private final List<Tarea> t1;

    public TareaRAdapter(List<Tarea> t) {
        this.t1 = t;
    }

    @NonNull
    @NotNull
    @Override
    public TareaViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.itemtarearecycle, parent, false);

        return new TareaRAdapter.TareaViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull @NotNull TareaViewHolder holder, int position) {
        Tarea t = t1.get(position);

        holder.task.setText(t.getTitulo());

        holder.sent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Context context = view.getContext();
                Intent intent = new Intent(context, tempActivity.class);
                intent.putExtra("dato_key", String.valueOf(t.getIdTarea()));
                context.startActivity(intent);
            }
        });
    }

    @Override
    public int getItemCount() {
        return t1.size();
    }

    public static class TareaViewHolder extends RecyclerView.ViewHolder {

        TextView task;

        Button sent;

        public TareaViewHolder(@NonNull @NotNull View itemView) {
            super(itemView);
            task = itemView.findViewById(R.id.task);
            sent = itemView.findViewById(R.id.sent);
        }
    }
}
