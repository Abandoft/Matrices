import 'DevUtils.dart';
import 'SquareMatrix.dart';

// 矩阵类
class Matrix {
  // 矩阵通过List<double>类型的数组来表示
  List<List<double>> matrix = [[]];

  // 构造方法，通过List<List<double>>生成Matrix
  Matrix() {} // 默认不使用，仅作为脚手架
  Matrix.fromList(List<List<double>> lists) {
    matrix = lists;
  }

  // 命名构造方法，生成全0全1和全为某数字的矩阵
  Matrix.zero(int row, int column) {
    matrix = generateLists(0, row, column);
  }
  Matrix.one(int row, int column) {
    this.matrix = generateLists(1, row, column);
  }
  Matrix.number(double number, int row, int column) {
    this.matrix = generateLists(number, row, column);
  }
  // 命名构造方法，生成全为随机数的矩阵
  Matrix.random(int row, int column) {
    matrix = generateRandomLists(row, column);
  }

  @override
  String toString() {
    // 条件表达式判断matrix[0]的长度，若为0，则行数为0
    String matrix_tostring =
        'Matrix: ${(matrix[0].length == 0) ? 0 : matrix.length}x${matrix[0].length}\n';
    for (var list in matrix) {
      matrix_tostring += '$list\n';
    }
    return matrix_tostring;
  }

  // 获取矩阵的某一列
  List<double> column(int column) {
    List<double> list = [];
    for (var i = 0; i < matrix.length; i++) {
      list.add(this.matrix[i][column]);
    }
    return list;
  }

  // 获取转置矩阵
  Matrix transpose() {
    return Matrix.fromList(listsTranspose(this.matrix));
  }

  // 获取矩阵的行阶梯形
  Matrix rowEchelonForm() {
    int i, j, k;
    double temp;
    List<List<double>> mat = copyMatrix(this);
    // r表示秩，d表示当前正在哪一行
    int r = 0, d = 0;

    for (i = 0; i < mat[0].length; i++) {
      k = d; // mat[i][i] mat[i+1][i] ... mat[n][i]中绝对值最大的行位置
      for (j = d + 1; j < mat.length; j++) {
        if (mat[k][i].abs() < mat[j][i].abs()) {
          k = j;
        }
      }
      if (k != d) // 交换第i行和第k行，行列式该变号
      {
        for (j = i; j < mat[0].length; j++) {
          temp = mat[d][j];
          mat[d][j] = mat[k][j];
          mat[k][j] = temp;
        }
      }
      if (mat[d][i] == 0) // 当mat[i][i]为零是时，行列式为零
      {
        continue;
      } else {
        r = r + 1;
        for (j = 0; j < mat.length; j++) {
          if (j != d) {
            temp = -1 * mat[j][i] / mat[d][i];
            for (k = i; k < mat[0].length; k++) {
              mat[j][k] = mat[j][k] + temp * mat[d][k];
            }
          }
        }
        temp = mat[d][i];
        for (j = i; j < mat[0].length; j++) {
          mat[d][j] = mat[d][j] / temp;
        }
      }
      d = d + 1;
      if (d >= mat.length) {
        break;
      }
    }
    return Matrix.fromList(mat);
  }

  // 获取矩阵的秩
  int rank() {
    int i, j, k;
    double temp;
    List<List<double>> mat = copyMatrix(this);
    // r表示秩，d表示当前正在哪一行
    int r = 0, d = 0;

    for (i = 0; i < mat[0].length; i++) {
      k = d; // mat[i][i] mat[i+1][i] ... mat[n][i]中绝对值最大的行位置
      for (j = d + 1; j < mat.length; j++) {
        if (mat[k][i].abs() < mat[j][i].abs()) {
          k = j;
        }
      }
      if (k != d) // 交换第i行和第k行，行列式该变号
      {
        for (j = i; j < mat[0].length; j++) {
          temp = mat[d][j];
          mat[d][j] = mat[k][j];
          mat[k][j] = temp;
        }
      }
      if (mat[d][i] == 0) // 当a[i][i]为零是时，行列式为零
      {
        continue;
      } else {
        r = r + 1;
        for (j = 0; j < mat.length; j++) {
          if (j != d) {
            temp = -1 * mat[j][i] / mat[d][i];
            for (k = i; k < mat[0].length; k++) {
              mat[j][k] = mat[j][k] + temp * mat[d][k];
            }
          }
        }
        temp = mat[d][i];
        for (j = i; j < mat[0].length; j++) {
          mat[d][j] = mat[d][j] / temp;
        }
      }
      d = d + 1;
      if (d >= mat.length) {
        break;
      }
    }
    return r;
  }

  // 修改矩阵的某一列
  setColumn(List<double> list, int column) {
    if (matrix.length == list.length) {
      for (var i = 0; i < matrix.length; i++) {
        this.matrix[i][column] = list[i];
      }
    } else {
      print('Failed: Length of list is not match. ');
    }
  }

  // 增加一行元素
  addRow(List<double> list, int index) {
    this.matrix.insert(index, list);
  }

  // 增加一列元素
  addColumn(List<double> list, int index) {
    for (var i = 0; i < matrix.length; i++) {
      this.matrix[i].insert(index, list[i]);
    }
  }

  // 按行追加一个矩阵的每一行
  appendRows(Matrix injected) {
    this.matrix.addAll(injected.matrix);
  }

  // 按列追加一个矩阵的每一列
  appendColumns(Matrix injected) {
    for (var i = 0; i < matrix.length; i++) {
      this.matrix[i].addAll(injected.matrix[i]);
    }
  }

  // 删除某一行元素：
  deleteRow(int index) {
    this.matrix.removeAt(index);
  }

  // 删除某一列元素：
  deleteColumn(int index) {
    for (var i = 0; i < matrix.length; i++) {
      this.matrix[i].removeAt(index);
    }
  }

  // 删除某几行元素：
  deleteRows(List<int> list) {
    int index = 0;
    for (int i in list) {
      this.matrix.removeAt(i - index);
      index++;
    }
  }

  // 删除某几列元素
  deleteColumns(List<int> list) {
    int temp = 0;
    for (int index in list) {
      for (var i = 0; i < matrix.length; i++) {
        this.matrix[i].removeAt(index - temp);
      }
      temp++;
    }
  }

  // 矩阵加法
  Matrix operator +(dynamic multi) {
    var result = Matrix();
    result.matrix = [];
    List<double> temp = [];
    if (multi is double || multi is int) {
      for (var i = 0; i < matrix.length; i++) {
        for (var j = 0; j < matrix[i].length; j++) {
          temp.add(this.matrix[i][j] + multi);
        }
        result.matrix.add(temp);
        temp = [];
      }
    }
    if (multi is Matrix) {
      for (var i = 0; i < this.matrix.length; i++) {
        for (var j = 0; j < multi.matrix[0].length; j++) {
          temp.add(this.matrix[i][j] + multi.matrix[i][j]);
        }
        result.matrix.add(temp);
        temp = [];
      }
    }
    return result;
  }

  // 矩阵减法
  Matrix operator -(dynamic multi) {
    var result = Matrix();
    result.matrix = [];
    List<double> temp = [];
    if (multi is double || multi is int) {
      for (var i = 0; i < matrix.length; i++) {
        for (var j = 0; j < matrix[i].length; j++) {
          temp.add(this.matrix[i][j] - multi);
        }
        result.matrix.add(temp);
        temp = [];
      }
    }
    if (multi is Matrix) {
      for (var i = 0; i < this.matrix.length; i++) {
        for (var j = 0; j < multi.matrix[0].length; j++) {
          temp.add(this.matrix[i][j] - multi.matrix[i][j]);
        }
        result.matrix.add(temp);
        temp = [];
      }
    }
    return result;
  }

  // 矩阵数乘&乘法
  Matrix operator *(dynamic multi) {
    var result = Matrix();
    result.matrix = [];
    List<double> temp = [];
    if (multi is double || multi is int) {
      for (var i = 0; i < matrix.length; i++) {
        for (var j = 0; j < matrix[i].length; j++) {
          temp.add(this.matrix[i][j] * multi);
        }
        result.matrix.add(temp);
        temp = [];
      }
    }
    if (multi is Matrix) {
      for (var i = 0; i < this.matrix.length; i++) {
        for (var j = 0; j < multi.matrix[0].length; j++) {
          temp.add(cross_product(this.matrix[i], multi.column(j)));
        }
        result.matrix.add(temp);
        temp = [];
      }
    }
    return result;
  }

  // 将矩阵截取为方阵
  SquareMatrix toSquare() {
    int length =
        matrix.length >= matrix[0].length ? matrix[0].length : matrix.length;
    List<List<double>> lists = [];
    List<double> temp = [];
    for (int i = 0; i < length; i++) {
      for (int j = 0; j < length; j++) {
        temp.add( matrix[i][j]);
      }
      lists.add(temp);
      temp=[];
    }
    return SquareMatrix.fromList(lists);
  }
}
