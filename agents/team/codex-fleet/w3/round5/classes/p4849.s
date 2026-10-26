# n=5 model=out iset=I1 prefix14_class=4849
cmp P1, P2
cmovge S2, P2
mov S0, P3
cmovle S2, P1
cmovg P2, P1
cmp S0, P0
cmovg S0, P0
cmovg P0, P3
cmp S2, S0
mov P1, S2
cmovg P1, S0
mov P1, P0
cmovg S0, S2
cmp P2, P1
