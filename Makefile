# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fvon-der <fvon-der@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/22 22:17:03 by fvon-de           #+#    #+#              #
#    Updated: 2024/11/04 17:01:09 by fvon-der         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


# Colors for output
RESET_COLOR	= \033[0m
YELLOW		= \033[1;33m
BLUE		= \033[1;34m
GREEN		= \033[1;32m
RED			= \033[1;31m

# Project settings
INCLUDE		= include
LIBFT		= ../libft
CC			= cc
CFLAGS		= -Wall -Wextra -Werror -Wunused -I$(INCLUDE) -I$(LIBFT)/include
DEBUG_FLAGS = $(CFLAGS) -g -O0 -Wall -Wextra -Werror -fsanitize=address -fsanitize=undefined \
			  -fno-strict-aliasing -fno-omit-frame-pointer -fstack-protector -DDEBUG -fno-inline
AR			 = ar rcs

# Default version if not specified
VERSION 	?= v1
SRC_DIR		= src/$(VERSION)
OBJ_DIR		= obj/$(VERSION)

# Source files for GNL
SRC_FILES =  \
			get_next_line.c  \
			get_next_line_utils.c \
			get_next_line_bonus.c \
			get_next_line_utils_bonus.c

# Define object files
OBJS = $(addprefix $(OBJ_DIR)/, $(notdir $(SRC_FILES:.c=.o)))

# Debug object files
DEBUG_OBJS = $(addprefix $(OBJ_DIR)/, $(addprefix debug_, $(notdir $(SRC_FILES:.c=.o))))

# Default rule to build
all: $(LIBFT)/libft.a $(OBJS) | $(OBJ_DIR)
	@echo "$(GREEN)GNL : Compilation complete!$(RESET_COLOR)"

# Debug build target
debug: $(LIBFT)/libft.a $(DEBUG_OBJS) | $(OBJ_DIR)
	@echo "$(GREEN)GNL : Debug compilation complete!$(RESET_COLOR)"

# Ensure object directory exists
$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

# Ensure libft.a exists
$(LIBFT)/libft.a:
	@$(MAKE) -C $(LIBFT)

# Build rule for GNL library
gnl.a: $(OBJS)
	@echo "$(YELLOW)GNL : Creating library gnl.a...$(RESET_COLOR)"
	@$(AR) gnl.a $(OBJS)
	@echo "$(GREEN)GNL : Library gnl.a created successfully!$(RESET_COLOR)"

# Rule for building normal object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "$(YELLOW)GNL : Compiling object file: $< to $@...$(RESET_COLOR)"
	@$(CC) $(CFLAGS) -c $< -o $@

# Rule for building debug object files
$(OBJ_DIR)/debug_%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "$(YELLOW)GNL : Compiling debug object file: $< to $@...$(RESET_COLOR)"
	@$(CC) $(DEBUG_FLAGS) -c $< -o $@

# Bonus target
bonus: all

# Clean object files
clean:
	@echo "$(RED)GNL : Cleaning object files in $(OBJ_DIR)...$(RESET_COLOR)"
	@rm -rf $(OBJ_DIR)

# Clean everything
fclean: clean 
	@echo "$(RED)GNL : Removing libraries...$(RESET_COLOR)"
	@rm -f gnl.a
	@$(MAKE) fclean -C $(LIBFT)

# Rebuild everything
re: fclean all

# Norminette target
norm:
	@echo "$(BLUE)GNL : Running Norminette...$(RESET_COLOR)"
	@norminette $(SRC_FILES) | grep -v 'OK!' || true
	@echo "$(GREEN)GNL : Norminette check complete!$(RESET_COLOR)"

# Version targets for different builds
v1: 
	@$(MAKE) VERSION=v1

#v2: 
#	@$(MAKE) VERSION=v2
#
#v3: 
#	@$(MAKE) VERSION=v3

# Phony Targets
.PHONY: all clean fclean re norm debug bonus v1 # v2 v3
