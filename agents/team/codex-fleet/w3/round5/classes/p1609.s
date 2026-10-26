# n=5 model=out iset=I1 prefix14_class=1609
mov S2, P3
cmp S2, P2
cmovl P3, P2
cmovge S2, P2
mov S0, P0
cmp P1, S0
cmovg S0, P1
cmovg P1, P0
cmovle P0, P1
cmp S2, P1
cmovl P0, S2
cmovle S2, P1
cmp S0, P3
cmovge P1, P3
