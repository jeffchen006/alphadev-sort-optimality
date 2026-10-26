# n=5 model=out iset=I1 prefix14_class=10015
cmp P2, P1
cmovg S1, P1
cmovle S1, P2
cmovge P1, P2
cmp P0, P3
cmovg S2, P3
cmovg P3, P0
cmovg P0, S2
cmp P3, P1
cmovle P2, P3
cmovle P3, P1
cmovl P1, P2
mov S0, S1
cmp S0, P0
