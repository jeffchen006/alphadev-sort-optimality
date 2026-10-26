# n=5 model=out iset=I1 prefix14_class=12959
cmp P1, P0
mov S0, P0
cmovle P0, P1
cmovg S0, P1
cmp P3, P2
mov S2, P0
cmovg P1, P2
cmovge P2, P3
cmovg P3, P1
cmp P0, P3
cmovg S2, P3
cmovl P0, P3
cmp P2, S0
cmovle S2, P2
