# n=5 model=out iset=I1 prefix14_class=5964
cmp P1, P0
mov S0, P2
mov S1, P1
cmovl S1, P0
cmovle P0, P1
cmp P2, P3
cmovl S0, P3
cmovg P2, P3
mov P3, S0
cmp P3, S1
cmovle P3, S1
cmovg S0, S1
cmp P0, P2
cmovge P3, P0
