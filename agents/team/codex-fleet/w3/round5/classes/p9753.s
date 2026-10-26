# n=5 model=out iset=I1 prefix14_class=9753
mov S1, P0
cmp S1, P1
cmovg S1, P1
mov S2, S1
cmovge P1, P0
cmp P2, P3
cmovle P0, P3
cmovl P3, P2
cmovle P2, P0
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovg P1, P2
cmp S2, P3
