# n=5 model=out iset=I1 prefix14_class=789
cmp P3, P2
cmovl S0, P3
cmovle P3, P2
cmovge S0, P2
cmovle P2, S0
cmp P0, P1
cmovg S2, P0
cmovle S2, P1
cmovg P0, P1
mov P1, S2
cmp S2, P3
cmovg S2, P3
cmovge P3, P1
mov P1, S2
