# n=5 model=out iset=I1 prefix14_class=888
cmp P2, P3
mov S2, P3
cmovl P3, P2
cmovle P2, S2
cmp P0, P1
cmovg S1, P1
cmovge P1, P0
mov S0, P1
cmovle S1, P0
cmp P2, S0
cmovle P1, P2
mov S2, P3
cmovge S0, P2
cmp S2, S1
