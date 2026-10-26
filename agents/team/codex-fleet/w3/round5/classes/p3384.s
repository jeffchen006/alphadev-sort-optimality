# n=5 model=out iset=I1 prefix14_class=3384
mov S2, P2
cmp P3, S2
cmovl P2, P3
cmovg S2, P3
mov S1, P0
cmp P1, P0
cmovge P0, P1
cmovle S1, P1
cmp P2, S1
mov P1, S1
cmovg P1, P2
cmovge P2, S1
cmp S2, P0
cmovge S0, S2
