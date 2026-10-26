# n=5 model=out iset=I1 prefix14_class=3816
mov S1, P2
cmp P2, P1
cmovg S1, P1
mov S0, P3
cmovge P1, P2
cmp P0, P3
cmovle P3, P0
mov S2, P3
cmovg S0, P0
cmp S2, S1
cmovl S2, S1
cmovle S1, P3
mov S1, S2
cmp P1, S0
