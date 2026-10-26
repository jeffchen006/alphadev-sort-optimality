# n=5 model=out iset=I1 prefix14_class=7891
cmp P2, P3
mov S1, P3
mov S0, P0
cmovge P3, P2
cmovle S1, P2
cmp S0, P1
cmovl P0, P1
cmovg S0, P1
cmp S1, S0
cmovg P2, S1
cmovge S1, S0
cmovg S0, P2
cmp P0, P3
cmovle P2, P3
