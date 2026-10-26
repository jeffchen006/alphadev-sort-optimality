# n=5 model=out iset=I1 prefix14_class=4817
mov S0, P3
cmp P2, P3
cmovle P3, P2
cmovg S0, P2
mov P2, P1
cmp P2, P0
cmovge P2, P0
cmovg P0, P1
mov S1, P3
cmp P2, P3
cmovl S1, P2
cmovg P3, P2
cmp P0, S0
cmovle P1, S0
