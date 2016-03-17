/**
 *
 * @brief Add function declarations
 *
 * @file add.h
 * @author Guillermo Hernández
 * @date 16 Mar 2016
 *
 */

#ifndef ADD_H_
#define ADD_H_

/**
 * @brief Adds two vectors
 *
 * Computes the vector addition of @p A and @p B into @p C, all of them having @p n elements.
 * Remember vector addition is given by \f$c_i = a_i+b_i\f$.
 * @param A First vector
 * @param B Second vector
 * @param C Vector where A+B is stored
 * @param n Length of the vectors
 */
int Add(const float *A, const float *B, float *C, int n);
/**
 * @brief CPU implementation of Add()
 */
int AddCPU(const float *A, const float *B, float *C, int n);
/**
 * @brief GPU implementation of Add()
 */
int AddGPU(const float *A, const float *B, float *C, int n);



#endif /* ADD_H_ */
