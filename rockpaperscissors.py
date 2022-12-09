# Define the possible choices
choices = ["rock", "paper", "scissors"]

# Prompt the user for their choice
user_choice = input("Enter your choice: rock, paper, or scissors? ")

# Check if the user's choice is valid
if user_choice not in choices:
  print("Invalid choice. Please try again.")
else:
  # Generate a random choice for the computer
  import random
  computer_choice = random.choice(choices)
  # Added line to print computer choice so user can be sure of result
  print("Computer chooses", computer_choice)

  # Compare the user's choice and the computer's choice to determine the winner
  if user_choice == computer_choice:
    print("It's a tie!")
  elif (user_choice == "rock" and computer_choice == "scissors") or \
       (user_choice == "paper" and computer_choice == "rock") or \
       (user_choice == "scissors" and computer_choice == "paper"):
    print("You win!")
  else:
    print("The computer wins!")
