# n=5 model=out iset=I1 prefix14_class=1801
mov S1, P3
cmp P1, P0
mov S0, P0
cmovg S0, P1
cmovg P1, P0
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
mov P3, S1
cmp S0, S1
cmovle S1, S0
cmovl S0, P3
cmp P1, P2
cmovge S0, P2
