# n=5 model=out iset=I1 prefix14_class=10934
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
cmovg S0, P2
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
mov S1, P1
cmovg P0, P2
cmp P0, S1
cmovl P1, P0
cmovg S1, P0
cmp S0, P3
cmovle P0, P3
