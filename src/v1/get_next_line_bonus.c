/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_bonus.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: fvon-der <fvon-der@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/25 20:05:51 by fvon-der          #+#    #+#             */
/*   Updated: 2024/10/25 20:05:59 by fvon-der         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/get_next_line.h"

/* 
static buffer 
		- leftover data between calls.
copy_full_line to start constructing the line from buffer.
Updates bufer with any remaining data after the newline.
extract_line to read more data if the newline wasn't found.
		- this doeas the
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

char	*copy_full_line(char *buffer, int *eol_posi)
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
		*eol_posi = len - 1;
	return (line);
}

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

// ZEROING THE BUFFER IS ABSOLUTLY NECESSARY
char	*eof_residue(int fd, char *line, char *buffer, int *eol_posi)
{
	char	new_buffer[BUFFER_SIZE + 1];
	ssize_t	read_bytes;
	size_t	line_size;

	while (*eol_posi == -1)
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
		line = ft_partstrjoin(line, new_buffer, eol_posi);
		if (read_bytes == 0)
			break ;
	}
	return (line);
}
