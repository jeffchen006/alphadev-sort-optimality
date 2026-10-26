# n=5 model=out iset=I1 prefix14_class=9591
cmp P2, P3
mov S1, P2
cmovle S1, P3
cmovl P3, P2
mov S2, P0
cmp P1, S2
cmovge P0, P1
mov S0, S1
cmovge P1, S2
cmp S1, P0
cmovg S1, P0
cmovge P0, S0
cmp P1, P3
cmovle P2, P3
