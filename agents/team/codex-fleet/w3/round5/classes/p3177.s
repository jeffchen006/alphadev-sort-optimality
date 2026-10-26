# n=5 model=out iset=I1 prefix14_class=3177
cmp P3, P1
mov S2, P1
cmovg P1, P3
cmovle S2, P3
cmp P2, P0
cmovge P3, P2
cmovg P2, P0
cmovg P0, P3
cmp S2, P2
mov S0, P2
cmovl S0, S2
cmovle S2, P2
cmp P1, P0
mov S0, P0
