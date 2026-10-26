# n=5 model=out iset=I1 prefix14_class=14263
cmp P2, P1
cmovle S1, P1
cmovl P1, P2
mov S0, P3
cmovg S1, P2
cmp P0, P3
cmovl S0, P0
mov P2, S1
cmovge P3, P0
cmp P2, P3
cmovg S1, P3
cmovg P3, P2
cmp S0, P1
cmovle P2, S1
