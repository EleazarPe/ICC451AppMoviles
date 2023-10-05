package com.example.tarea3viewmodelrom.adapters;


import android.content.Context;
import android.content.Intent;
import android.graphics.Paint;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;


import com.example.tarea3viewmodelrom.R;
import com.example.tarea3viewmodelrom.data.TareaViewModel;
import com.example.tarea3viewmodelrom.encapsulaciones.Tarea;
import com.example.tarea3viewmodelrom.tempActivity;

import org.jetbrains.annotations.NotNull;

import java.util.List;
/*
public class TareaRAdapter extends RecyclerView.Adapter<TareaRAdapter.TareaViewHolder> {
    private LiveData<List<Tarea>> tareasLiveData;

    public TareaRAdapter(LiveData<List<Tarea>> tareasLiveData) {
        this.tareasLiveData = tareasLiveData;
    }

    @NonNull
    @NotNull
    @Override
    public TareaViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.itemtarearecycle, parent, false);
        return new TareaViewHolder(view);
    }
    public void setTareas(LiveData<List<Tarea>> tareas) {
        this.tareasLiveData = tareas;
        notifyDataSetChanged(); // Notifica al adaptador que los datos han cambiado
    }

    @Override
    public void onBindViewHolder(@NonNull @NotNull TareaViewHolder holder, int position) {
        List<Tarea> tareas = tareasLiveData.getValue();
        if (tareas != null && position < tareas.size()) {
            Tarea tarea = tareas.get(position);

            holder.task.setText(tarea.getTitulo());

            holder.sent.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Context context = view.getContext();
                    Intent intent = new Intent(context, tempActivity.class);
                    intent.putExtra("dato_key", String.valueOf(tarea.getIdTarea()));
                    context.startActivity(intent);
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        List<Tarea> tareas = tareasLiveData.getValue();
        return tareas != null ? tareas.size() : 0;
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
}*/

public class TareaRAdapter extends ListAdapter<Tarea, TareaRAdapter.TareaViewHolder> {


    public TareaRAdapter(@NonNull @NotNull DiffUtil.ItemCallback<Tarea> diffCallback) {
        super(diffCallback);
    }

    @NonNull
    @NotNull
    @Override
    public TareaViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        return TareaViewHolder.create(parent);
    }

    public static class TareadDiff extends DiffUtil.ItemCallback<Tarea> {

        @Override
        public boolean areItemsTheSame(@NonNull Tarea oldItem, @NonNull Tarea newItem) {
            return oldItem == newItem;
        }

        @Override
        public boolean areContentsTheSame(@NonNull Tarea oldItem, @NonNull Tarea newItem) {
            return oldItem.getIdTarea() == newItem.getIdTarea();
        }
    }



    @Override
    public void onBindViewHolder(@NonNull @NotNull TareaViewHolder holder, int position) {
        Tarea t = getItem(position);
        if(t.getEstado() == true){
            holder.task.setPaintFlags(holder.task.getPaintFlags() |Paint.STRIKE_THRU_TEXT_FLAG);
            holder.cheki.setChecked(true);
            holder.task.setText(t.getTitulo());
        }else{
            holder.task.setText(t.getTitulo());
            holder.cheki.setChecked(false);
            holder.task.setPaintFlags(holder.task.getPaintFlags() &(~Paint.STRIKE_THRU_TEXT_FLAG));

        }

        holder.sent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Context context = view.getContext();
                Intent intent = new Intent(context, tempActivity.class);
                intent.putExtra("dato_key",  t);
                context.startActivity(intent);
            }
        });
        holder.cheki.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(holder.cheki.isChecked()) {
                    TareaViewModel tmodel = new ViewModelProvider((AppCompatActivity) view.getContext()).get(TareaViewModel.class);
                    t.setEstado(true);
                    tmodel.update(t);
                }else{
                    TareaViewModel tmodel = new ViewModelProvider((AppCompatActivity) view.getContext()).get(TareaViewModel.class);
                    t.setEstado(false);
                    tmodel.update(t);
                }

            }
        });
    }


    public static class  TareaDiff extends DiffUtil.ItemCallback<Tarea>{

        @Override
        public boolean areItemsTheSame(@NonNull Tarea oldItem, @NonNull Tarea newItem) {
            return oldItem == newItem;
        }

        @Override
        public boolean areContentsTheSame(@NonNull Tarea oldItem, @NonNull Tarea newItem) {
            return oldItem.getIdTarea()==newItem.getIdTarea();
        }
    }

    public static class TareaViewHolder extends RecyclerView.ViewHolder {

        TextView task;

        Button sent;
        CheckBox cheki;

        public TareaViewHolder(@NonNull @NotNull View itemView) {
            super(itemView);
            task = itemView.findViewById(R.id.task);
            sent = itemView.findViewById(R.id.sent);
            cheki = itemView.findViewById(R.id.cheki);
        }

        public static TareaViewHolder create(ViewGroup parent) {
            View view = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.itemtarearecycle, parent, false);
            return new TareaViewHolder(view);
        }
    }
}
