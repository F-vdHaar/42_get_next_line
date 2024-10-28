/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: fvon-der <fvon-der@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/22 22:25:47 by fvon-de           #+#    #+#             */
/*   Updated: 2024/10/28 13:57:29 by fvon-der         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

/* 
Read the next line from a file descriptor using a static buffer
Return pointer to the line read or NULL on failure or EOF
Static buffer holds leftover data between calls
- copy_full_line constructs the line from buffer
- shift_buffer removes the processed line
- eof_residue indicates if a newline was found
*/
char	*get_next_line(int fd)
{
	static char	buffer[BUFFER_SIZE + 1];
	char		*line;
	int			eol_loc;

	if (fd < 0 || BUFFER_SIZE <= 0)
		return (NULL);
	eol_loc = -1;
	line = copy_full_line(buffer, &eol_loc);
	if (!line)
		return (NULL);
	shift_buffer(buffer, &buffer[eol_loc + 1], BUFFER_SIZE + 1);
	if (eol_loc < 0)
	{
		line = eof_residue(fd, line, buffer, &eol_loc);
		if (!line || line[0] == '\0')
		{
			free(line);
			return (NULL);
		}
	}
	return (line);
}

// Copy a full line from buffer to a new string
// Update eol_loc with position of last newline
// Return pointer to newly allocated line, or NULL on failure
// Calculate length
//Allocate memory for line and null terminator
//Copy line contents
//Update eol_loc
char	*copy_full_line(char *buffer, int *eol_loc)
{
	size_t	len;
	char	*line;

	len = 0;
	while (buffer[len] && buffer[len] != '\n')
		len++;
	len++;
	line = malloc(sizeof(char) * (len + 1));
	if (!line)
		return (NULL);
	ft_memcpy(line, buffer, len);
	line[len] = '\0';
	if (len > 0 && line[len - 1] == '\n')
		*eol_loc = len - 1;
	return (line);
}

// Locate the end of line in a string
// Return position after newline or end of string
// Return -1 if input line is NULL
size_t	find_eol(char *line)
{
	size_t	i;

	i = 0;
	if (!line)
		return (-1);
	while (i < BUFFER_SIZE)
	{
		if (line[i] == '\n' || line[i] == '\0')
			return (i + 1);
		i++;
	}
	return (i);
}

// Read from file descriptor until newline or EOF
// Append to existing line with ft_partstrjoin
// Return updated line or NULL on failure
// Ensure buffer is zeroed to avoid corruption
// ZEROING THE BUFFER IS ABSOLUTLY NECESSARY to avoid corruption
char	*eof_residue(int fd, char *line, char *buffer, int *eol_loc)
{
	char	new_buffer[BUFFER_SIZE + 1];
	ssize_t	read_bytes;
	size_t	line_size;

	while (*eol_loc == -1)
	{
		ft_bzero(new_buffer, (BUFFER_SIZE + 1));
		read_bytes = read(fd, new_buffer, BUFFER_SIZE);
		if (read_bytes == -1)
		{
			free(line);
			ft_bzero(buffer, (BUFFER_SIZE + 1));
			return (NULL);
		}
		line_size = find_eol(new_buffer);
		shift_buffer(buffer, &new_buffer[line_size], (BUFFER_SIZE + 1));
		new_buffer[line_size] = '\0';
		line = ft_strjoin(line, new_buffer, eol_loc);
		if (read_bytes == 0)
		{
			ft_bzero(buffer, BUFFER_SIZE + 1);
			break ;
		}
	}
	return (line);
}
