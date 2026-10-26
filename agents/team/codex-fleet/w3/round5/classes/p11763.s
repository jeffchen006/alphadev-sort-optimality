# n=5 model=out iset=I1 prefix14_class=11763
mov S2, P3
cmp S2, P0
cmovg S2, P0
cmovg P0, P3
cmp P1, P2
mov S1, P0
cmovle S0, P1
cmovl P1, P2
cmovl P2, S0
cmp P1, P0
cmovg P0, P1
cmovge P1, S1
cmp S2, P2
cmovle P0, P2
