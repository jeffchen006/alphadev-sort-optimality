# n=5 model=out iset=I1 prefix14_class=11740
cmp P1, P3
mov S0, P3
cmovg S0, P1
cmovle P3, P1
mov S1, S0
cmp P2, P0
cmovge P1, P2
cmovg P2, P0
cmovge P0, P1
cmp S0, P0
cmovle S1, P0
cmovl P0, S0
cmp P3, P2
cmovle S2, P3
