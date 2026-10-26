# n=5 model=out iset=I1 prefix14_class=3988
mov S2, P1
cmp S2, P2
cmovle S2, P2
cmovge P1, P2
mov S1, P0
cmp S1, P3
cmovg S1, P3
cmovg P3, P0
mov P0, P1
cmp P1, S1
cmovg P1, S1
cmovg S1, P0
cmp P3, S2
cmovl S0, P3
