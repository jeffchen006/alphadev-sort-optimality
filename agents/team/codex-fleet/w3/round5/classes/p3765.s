# n=5 model=out iset=I1 prefix14_class=3765
mov S0, P1
cmp P0, S0
cmovl S0, P0
mov S1, S0
cmovg P1, P0
mov S2, P2
cmp P3, S2
cmovg S2, P3
cmovge P3, P2
cmp S0, P3
cmovle S0, P3
cmovle P3, S1
cmp P1, S2
cmovge P3, S2
