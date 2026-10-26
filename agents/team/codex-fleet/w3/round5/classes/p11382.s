# n=5 model=out iset=I1 prefix14_class=11382
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovle P1, S1
cmp P3, P0
mov S2, P3
cmovg S2, P0
cmovl P3, P0
cmp P3, P1
cmovge P0, P1
cmovge P1, P3
cmovg P3, P0
cmp S2, P2
mov S0, P3
