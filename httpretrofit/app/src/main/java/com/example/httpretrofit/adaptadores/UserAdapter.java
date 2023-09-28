package com.example.httpretrofit.adaptadores;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.httpretrofit.DTO.User;
import com.example.httpretrofit.InfoRecycle;
import com.example.httpretrofit.R;

import org.jetbrains.annotations.NotNull;

import java.util.List;

public class UserAdapter extends RecyclerView.Adapter<UserAdapter.StudenViewHolder> {

    private static List<User> students = null;

    public UserAdapter(List<User> students) {
        this.students = students;
    }

    @NonNull
    @NotNull
    @Override
    public StudenViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_student, parent, false);

        return new UserAdapter.StudenViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull @NotNull StudenViewHolder holder, int position) {
        User student = students.get(position);

        holder.name.setText(student.getFirstName()+student.getLastName());

    }

    @Override
    public int getItemCount() {
        return students.size();
    }

    public static class StudenViewHolder extends RecyclerView.ViewHolder {

        TextView name;

        private LinearLayout parentLayout;
        private Context context;
        public StudenViewHolder(@NonNull @NotNull View itemView) {
            super(itemView);
            name = itemView.findViewById(R.id.name);
            parentLayout = itemView.findViewById(R.id.linear_layout); // R.id.parent_layout es el ID del LinearLayout en item_info_recycle.xml
            context = itemView.getContext();

            parentLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int position = getAdapterPosition();
                    User user = students.get(position);
                    Intent intent = new Intent(context, InfoRecycle.class);
                    intent.putExtra("dato_key", String.valueOf(user.getId()));
                    context.startActivity(intent);
                }
            });

        }
    }

}
