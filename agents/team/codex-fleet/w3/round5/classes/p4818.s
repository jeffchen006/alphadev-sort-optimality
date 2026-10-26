# n=5 model=out iset=I1 prefix14_class=4818
cmp P3, P1
mov S0, P1
cmovl P1, P3
cmovg S0, P3
mov P3, P2
cmp P3, P0
cmovg P3, P0
mov S1, P1
cmovge P0, P2
cmp P3, S1
cmovge P1, P3
cmovl S1, P3
cmp P0, S0
cmovle S1, S0
