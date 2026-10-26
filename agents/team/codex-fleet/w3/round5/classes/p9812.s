# n=5 model=out iset=I1 prefix14_class=9812
cmp P2, P1
cmovg S0, P2
cmovge P2, P1
cmovle S0, P1
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
mov P1, S0
cmovl P3, S1
cmp P3, S0
cmovg P1, P3
cmovg P3, S0
cmp P0, P2
cmovge P1, P0
