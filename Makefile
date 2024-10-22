# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fvon-de <fvon-der@student.42heilbronn.d    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/22 22:17:03 by fvon-de           #+#    #+#              #
#    Updated: 2024/10/22 22:20:28 by fvon-de          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Colors for output
RESET_COLOR = \033[0;39m
YELLOW      = \033[0;93m
BLUE        = \033[0;94m
GREEN       = \033[0;92m
RED         = \033[1;31m

# Project settings
INCLUDE     = include
LIBFT       = lib/libft
CC			= cc
CFLAGS 		= -Wall -Wextra -Werror -Wunused -I$(INCLUDE) -I$(LIBFT)/include
DEBUG_FLAGS = -g -O0 -Wall -Wextra -Werror -fsanitize=address -fsanitize=undefined -fno-strict-aliasing -fno-omit-frame-pointer -fstack-protector -DDEBUG -fno-inline
MAKE        = make

 # Default version if not specified
VERSION ?= v1
SRC_DIR = src/$(VERSION)
OBJ_DIR = obj/$(VERSION)

# Source files
SRC_FILES =  \
            get_next_line.c  \
            get_next_line_utils.c

# Define object files manually
OBJS =  \
        $(OBJ_DIR)/get_next_line.o \
        $(OBJ_DIR)/get_next_line_utils.o

# Debug objects
DEBUG_OBJS =  \
            $(OBJ_DIR)/debug_get_next_line.o \
            $(OBJ_DIR)/debug_get_next_line_utils.o \


# Default rule to build 
all: $(LIBFT)/libft.a $(OBJS) | $(OBJ_DIR)

# Debug build target
debug: $(LIBFT)/libft.a $(DEBUG_OBJS) | $(OBJ_DIR)

# Ensure object directory exists
$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

# Ensure libft.a exists
$(LIBFT)/libft.a:
	@$(MAKE) -C $(LIBFT)

#  build rule
$(NAME): $(OBJ_DIR) $(OBJS)
	@echo "$(YELLOW)FT_PRINTF : Creating library $(NAME)...$(RESET_COLOR)"
	@$(AR) $(NAME) $(OBJS) $(LIBFT)/libft.a
	@echo "$(GREEN)$(NAME) creation finished!$(RESET_COLOR)"

# Rule for building normal object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "$(YELLOW)GNL : Compiling object file: $< to $@...$(RESET_COLOR)"
	@$(CC) $(CFLAGS) -c $< -o $@

# Rule for building debug object files
$(OBJ_DIR)/debug_%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "$(YELLOW)GNL: Compiling debug object file: $< to $@...$(RESET_COLOR)"
	@$(CC) $(DEBUG_FLAGS) -c $< -o $@

# bonus target
# TODO Implment bonus.
bonus: all

# Clean object files
clean:
	@echo "$(RED)GNL: Cleaning object files in $(OBJ_DIR)...$(RESET_COLOR)"
	@rm -rf $(OBJ_DIR)

# Clean everything
fclean: clean 
	@$(MAKE) fclean -C $(LIBFT)

# Rebuild everything
re: fclean all

# Norminette target
norm:
	@echo "$(BLUE)GNL : Running Norminette...$(RESET_COLOR)"
	@norminette $(SRCS) | grep -v 'OK!' || true
	@echo "$(GREEN)Norminette check complete!$(RESET_COLOR)"


# Version targets for different builds
v1: 
	@$(MAKE) VERSION=v1

# v2: 
# 	@$(MAKE) VERSION=v2

# v3: 
# 	@$(MAKE) VERSION=v3

.PHONY: all clean fclean re norm debug bonus v1 # v2 v3
