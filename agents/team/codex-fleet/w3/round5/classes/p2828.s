# n=5 model=out iset=I1 prefix14_class=2828
cmp P1, P0
mov S1, P1
cmovl P1, P0
cmovg S1, P0
cmp P2, P3
cmovg S2, P3
cmovle S2, P2
mov S0, P1
cmovg P3, P2
cmp S0, P3
cmovle P1, P3
cmovle P3, S0
cmp S2, S1
cmovge P2, S2
