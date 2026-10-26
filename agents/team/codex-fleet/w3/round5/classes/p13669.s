# n=5 model=out iset=I1 prefix14_class=13669
cmp P3, P0
cmovle S2, P0
mov S1, P1
cmovl P0, P3
cmovl P3, S2
cmp S1, P2
mov S0, P3
cmovg S1, P2
cmovle P1, P2
cmp P3, P1
cmovge P3, P1
cmovge P1, S0
cmp P0, S1
mov S0, P3
