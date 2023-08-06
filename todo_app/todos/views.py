from django.shortcuts import render, redirect
from django.http import HttpResponse, HttpRequest
from django.db import connection
from .models import Todo

# Create your views here.


def list_todo_items(request):
    context = {'todo_list' : Todo.objects.all()}
    return render(request, 'todos/todo_list.html',context)


def insert_todo_item(request: HttpRequest):
    todo = Todo(content=request.POST['content'])
    todo.save()
    return redirect('/todos/list/')

def delete_todo_item(request,todo_id):
    todo_to_delete = Todo.objects.get(id=todo_id)
    todo_to_delete.delete()
    return redirect('/todos/list/')

def health(request: HttpRequest):
    with connection.cursor() as cursor:
        cursor.execute("select 1")
        one = cursor.fetchone()[0]
        if one != 1:
            raise Exception('The site did not pass the health check')
    return HttpResponse(status=200)