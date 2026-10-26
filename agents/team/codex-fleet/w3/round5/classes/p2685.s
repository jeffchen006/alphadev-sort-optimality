# n=5 model=out iset=I1 prefix14_class=2685
mov S0, P2
mov S2, P0
cmp S2, P1
cmovg S2, P1
cmovge P1, P0
cmp S0, P3
cmovle P2, P3
cmovge S0, P3
cmp P1, P2
cmovl P3, P1
cmovle P1, P2
cmovge P3, P2
cmp S0, S2
cmovg P2, P3
