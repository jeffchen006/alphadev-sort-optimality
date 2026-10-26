# n=5 model=out iset=I1 prefix14_class=6448
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovg S2, P3
mov P3, P0
cmp P3, P1
cmovge P0, P1
cmovge P1, P3
mov P1, S2
cmp S2, P2
