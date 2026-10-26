# n=5 model=out iset=I1 prefix14_class=6979
cmp P0, P2
cmovg S0, P2
mov S1, P3
cmovg P2, P0
cmovg P0, S0
cmp P1, P3
cmovge P3, P1
mov S2, P2
cmovle S1, P1
cmp P2, P3
cmovg P2, P3
cmovl S2, P3
cmp S1, P0
cmovg S2, P0
