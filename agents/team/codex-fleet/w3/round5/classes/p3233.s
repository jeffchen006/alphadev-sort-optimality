# n=5 model=out iset=I1 prefix14_class=3233
cmp P1, P2
mov S2, P2
mov S1, P0
cmovle S2, P1
cmovge P2, P1
cmp P3, P0
cmovg S1, P3
cmovl P0, P3
cmp S2, P0
cmovg S0, P0
cmovge P0, S2
mov P3, S1
cmovg S2, S0
cmp P2, S1
