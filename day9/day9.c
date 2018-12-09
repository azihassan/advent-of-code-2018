#include <stdio.h>
#include <malloc.h>

typedef struct Node
{
    int value;
    struct Node* next;
    struct Node* prev;
} Node;

Node* new_list()
{
    Node* new = (Node *) malloc(sizeof(Node));
    new->value = 0;
    new->next = new;
    new->prev = new;
    return new;
}

Node* new_node(int value)
{
    Node* new = (Node *) malloc(sizeof(Node));
    new->value = value;
    return new;
}

void add(Node* current, int value)
{
    Node *new = new_node(value);
    Node *prev = current;
    Node *next = current->next;

    current->next = new;
    new->prev = current;
    new->next = next;
    next->prev = new;
}

void delete(Node *current)
{
    Node *prev = current->prev;
    Node *next = current->next;
    prev->next = next;
    next->prev = prev;
    free(current);
}

void clean(Node *head)
{
    Node *current = head;
    do
    {
        Node *to_delete = current;
        current = current->next;
        free(to_delete);
    }
    while(current != head);
}

int main()
{
    size_t player_count;
    int last_marble;
    scanf("%lu players; last marble is worth %d points", &player_count, &last_marble);
    Node* circle = new_list();
    Node* head = circle;
    unsigned long long scores[player_count];
    unsigned long long highest_score = 0;

    size_t current_player;
    for(current_player = 0; current_player < player_count; current_player++)
    {
        scores[current_player] = 0;
    }
    current_player = 0;

    for(int current_marble = 1; current_marble < last_marble; current_marble++)
    {
        if(current_marble % 23 == 0)
        {
            scores[current_player] += current_marble;
            for(int i = 0; i < 7; i++, circle = circle->prev);
            scores[current_player] += circle->value;
            highest_score = scores[current_player] > highest_score ? scores[current_player] : highest_score;

            circle = circle->next;
            delete(circle->prev);
        }
        else
        {
            circle = circle->next;
            add(circle, current_marble);
            circle = circle->next;
        }
        current_player++;
        if(current_player == player_count)
        {
            current_player = 0;
        }
    }

    printf("%llu\n", highest_score);
    clean(head);
}
