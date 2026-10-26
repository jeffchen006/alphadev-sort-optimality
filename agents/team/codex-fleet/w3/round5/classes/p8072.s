# n=5 model=out iset=I1 prefix14_class=8072
mov S0, P2
cmp P2, P3
cmovle S0, P3
cmovge P2, P3
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
mov P3, P2
cmp P2, P1
cmovl P3, P1
cmovg P2, P1
cmp S0, P0
mov P2, P0
